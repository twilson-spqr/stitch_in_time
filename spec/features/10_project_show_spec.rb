require 'rails_helper'

feature 'show project page', %(
  As a user, view individual projects.
) do

  before(:each) do
    @bob = create(:user)
    @skunk_works = create(:project)

    login_as @bob
    visit project_path @skunk_works
  end

  it 'shows project details' do
    t = Time.zone.now
    5.times do |n|
      i = t - (n+1).hours
      o = t - (n*30).minutes
      p = create(:punch, time_in: i, time_out: o )
      p.adjust_time
    end
    p = create(:punch, time_in: (t - 17.minutes), time_out: t)
    p.adjust_time

    visit project_path @skunk_works

    expect(page).to have_content @skunk_works.name
    expect(page).to have_content @skunk_works.description
    expect(page).to have_content("10:17:00")
  end

  it 'lists punches in order from newest to oldest' do
    t = Time.now
    15.times do |n|
      start_time = (t - (n*20).minutes)
      end_time = (start_time + 10.minutes)
      Punch.create(project: @skunk_works, time_in: start_time, time_out: end_time)
    end
    oldest = Punch.last
    oldest.update(comment: "I am the oldest")
    newest = create(:punch, time_in: t + 10.minutes, comment: "I am the newest comment")
    visit project_path @skunk_works

    expect(page).to have_link newest.comment
    expect(page).to_not have_link oldest.comment
  end
end
