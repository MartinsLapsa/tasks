require_relative '../rails_helper'

describe "Tasks" do
  let!(:task) { create :task }
  let(:user) { task.author }
  let!(:other_user) { create :user }

  before do
    login_as user
  end

  it 'can edit task' do
    visit task_path(task)
    click_on 'Edit this task'

    fill_in 'Name', with: 'New name'
    fill_in 'Description', with: 'Some description'
    fill_in 'Deadline', with: '01.01.2023'
    select  other_user.to_s, from: 'Responsible'

    click_on 'Update Task'

    expect(page).to have_content 'Task was successfully updated.'

    expect(page).to have_content "Name: New name"
    expect(page).to have_content "Description: Some description", normalize_ws: true
    expect(page).to have_content "Deadline: 2023-01-01"
    expect(page).to have_content "Responsible: #{other_user.email}"
  end

  it 'can delete task' do
    visit task_path(task)
    click_button 'Destroy this task'

    expect(page).to have_content 'Task was successfully destroyed.'
    expect(page).to_not have_content task.name
  end

  it 'can not start task' do
    visit task_path(task)
    expect(page).not_to have_button 'Start'
  end

  context 'user is responsible' do
    let(:user) { task.responsible }

    it 'can start task' do
      visit task_path(task)
      click_button 'Start'

      expect(page).to have_content 'Task has been started.'
      expect(page).to have_content 'State: In progress'
      expect(page).not_to have_button 'Start'
    end

    context 'task is in progress' do
      let!(:task) { create :task, state: :in_progress }

      it 'can finish task' do
        visit task_path(task)
        click_button 'Finish'

        expect(page).to have_content 'Task has been finished.'
        expect(page).to have_content 'State: Done'
        expect(page).not_to have_button 'Finish'
      end

      it 'can cancel task' do
        visit task_path(task)
        click_button 'Cancel'

        expect(page).to have_content 'Task has been cancelled.'
        expect(page).to have_content 'State: Cancelled'
        expect(page).not_to have_button 'Cancel'
      end
    end
  end
end
