require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    context 'owner' do
      it 'deletes answer belonging to user' do
        sign_in(question.user)

        expect { delete :destroy, params: { id: attachment, format: :json } }.to change(question.attachments, :count).by(-1)
      end

      it 'removing attachment from view' do
        sign_in(question.user)

        delete :destroy, params: { id: attachment, format: :json }
        expect(response.status).to eq 204
      end
    end

    it "doesn't delete question belonging to somebody else" do
      expect { delete :destroy, params: { id: attachment, format: :json } }.not_to change(Attachment, :count)
      expect(response.status).to eq 401
    end
  end

end
