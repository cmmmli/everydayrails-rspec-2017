require 'rails_helper'

RSpec.describe Project, type: :model do
  # 重複のチェック
  describe "duplicate check" do
    before do
      @user = FactoryBot.create(:user)
    end

    it "does not allow duplicate project names per user" do
      @user.projects.create(
        name: "Test Project",
      )
      new_project = @user.projects.build(
        name: "Test Project",
      )

      new_project.valid?
      expect(new_project.errors[:name]).to include("has already been taken")
    end

    it "allows two users to share a project name" do
      @user.projects.create(
        name: "Test Project",
      )
      other_user = FactoryBot.create(:user)
      other_project = other_user.projects.build(
        name: "Test Project",
      )

      expect(other_project).to be_valid
    end
  end
  

  # 遅延ステータス
  describe "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :project_due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュール通りであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :project_due_today)
      expect(project).to_not be_late
    end
    # 締切日が未来ならスケジュール通りであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :project_due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it "can have many notes" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end
end
