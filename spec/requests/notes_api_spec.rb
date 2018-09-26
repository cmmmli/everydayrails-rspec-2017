require 'rails_helper'

RSpec.describe "Notes API", type: :request do
  # 1件のノートを読み出すこと
  it 'loads a note' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project,
      name: "Sample Project",
      owner: user)
    FactoryBot.create(:note,
      message: "Sample Note",
      user: user)
    FactoryBot.create(:note,
      message: "Second Sample Note",
      user: user,
      project: project)

    get api_project_notes_path(project_id: project.id), params: {
      user_email: user.email,
      user_token: user.authentication_token,
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1
    note_id = json[0]["id"]

    get api_project_note_path(project.id, note_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["message"]).to eq "Second Sample Note"
  end

  # # ノートを作成できること
  # it 'creates a note' do
  #   user = FactoryBot.create(:user)
  #   project = FactoryBot.create(:project,
  #     name: "Sample Project",
  #     owner: user)

  #   note_attributes = FactoryBot.attributes_for(:note,
  #     project: project)

  #   expect {
  #     post api_project_notes_path(project_id: project.id), params: {
  #       user_email: user.email,
  #       user_token: user.authentication_token,
  #       note: {message: "testttt"}
  #     }
  #   }.to change(project.notes, :count).by(1)

  #   expect(response).to have_http_status(:success)
  # end
end
