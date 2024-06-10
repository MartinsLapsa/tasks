require_relative '../rails_helper'

describe "Tasks" do
  let!(:user) { create :user }

  before do
    login_as user
  end

  context "multiple tasks" do
    let!(:task1) { create :task, responsible: user, state: :draft, deadline: 1.week.ago }
    let!(:task2) { create :task, responsible: user, state: :in_progress, deadline: Date.current }
    let!(:task3) { create :task, responsible: user, state: :cancelled, deadline: 1.day.ago }
    let!(:task4) { create :task, responsible: user, state: :done, deadline: 1.week.from_now }

    it 'can filter by state' do
      visit tasks_path

      filter_by_state('Draft')

      expect(page).to have_content(task1.name)
      expect_not_to_show_tasks [task2, task3, task4]

      filter_by_state('In progress')
      expect_not_to_show_tasks [task1, task3, task4]
      expect(page).to have_content(task2.name)

      filter_by_state('Cancelled')
      expect_not_to_show_tasks [task1, task2, task4]
      expect(page).to have_content(task3.name)

      filter_by_state('Done')
      expect_not_to_show_tasks [task1, task2, task3]
      expect(page).to have_content(task4.name)

      filter_by_state('Any')
      [task1, task2, task3, task4].each do |task|
        expect(page).to have_content(task.name)
      end
    end

    it 'can order by state' do
      visit tasks_path

      click_link 'State'
      expect(page).to have_content "State ▲"
      expect_task_order [task3, task4, task1, task2]

      click_link 'State'
      expect(page).to have_content "State ▼"
      expect_task_order [task2, task1, task4, task3]
    end

    it 'can order by deadline' do
      visit tasks_path

      click_link 'Deadline'
      expect(page).to have_content "Deadline ▲"
      expect_task_order [task1, task3, task2, task4]

      click_link 'Deadline'
      expect(page).to have_content "Deadline ▼"
      expect_task_order [task4, task2, task3, task1]
    end
  end

  it 'can create task' do
    other_user = create(:user)
    visit tasks_path
    click_link 'New task'

    fill_in 'Name', with: 'New name'
    fill_in 'Description', with: 'Some description'
    fill_in 'Deadline', with: '2023-01-01'
    select  other_user.to_s, from: 'Responsible'

    click_on 'Create Task'

    expect(page).to have_content 'Task was successfully created.'
  end

  def filter_by_state(state)
    select state, from: 'State'
    click_button 'Search'
  end

  def expect_task_order(tasks)
    task_names = all("[data-contains='task_name']").map(&:text)
    expect(task_names).to eq tasks.map(&:name)
  end

  def expect_not_to_show_tasks(tasks)
    tasks.each do |task|
      expect(page).not_to have_content(task.name)
    end
  end
end
