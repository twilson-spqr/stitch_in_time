class Punch < ApplicationRecord
  require 'hublot'
  belongs_to :project
  delegate :user, to: :project
  validates :time_in, presence: true
  validates :time_worked, presence: true
  default_scope -> { order(time_in: :desc) }


  def marker
    if self.comment?
      self.comment
    else
      self.time_in.pretty
    end
  end

  def active?
    self.time_out.nil?
  end

  def adjust_time
    self.project.update(time_worked: (self.project.time_worked - self.time_worked) )
    self.time_worked = self.time_out - self.time_in
    self.save
    self.project.update(time_worked: (self.project.time_worked + self.time_worked) )
  end
end
