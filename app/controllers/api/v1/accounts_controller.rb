module Api
  module V1
    class AccountsController < BaseController
      before_action :set_account, only: [ :show, :update, :destroy ]

      # GET /api/v1/accounts
      def index
        @accounts = current_user.accounts
        render json: @accounts
      end

      # GET /api/v1/accounts/:id
      def show
        render json: @account
      end

      # POST /api/v1/accounts
      def create
        @account = current_user.accounts.build(account_params)

        if @account.save
          render json: @account, status: :created
        else
          render json: { errors: @account.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/accounts/:id
      def update
        if @account.update(account_params)
          render json: @account
        else
          render json: { errors: @account.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/accounts/:id
      def destroy
        @account.destroy
        head :no_content
      end

      private

      def set_account
        @account = current_user.accounts.find(params[:id])
      end

      def account_params
        params.require(:account).permit(:name, :account_type, :balance, :currency, :number, :bank_name)
      end
    end
  end
end
