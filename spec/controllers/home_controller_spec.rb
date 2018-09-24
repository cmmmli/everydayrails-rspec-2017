require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  # 正常にレスポンスを返すこと
  it "responds successfully" do
    get :index
    expect(response).to have_http_status "200"
  end
end
