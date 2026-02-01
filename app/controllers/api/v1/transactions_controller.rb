module Api
  module V1
    class TransactionsController < BaseController
      before_action :set_transaction, only: [ :show, :update, :destroy ]
      before_action :set_account, only: [ :index, :create ]

      # GET /api/v1/accounts/:account_id/transactions
      # GET /api/v1/transactions
      def index
        if @account
          @transactions = @account.transactions.by_date
        else
          # Get all transactions for the user's accounts
          @transactions = Transaction.joins(:account)
                                     .where(accounts: { user_id: current_user.id })
                                     .by_date
        end

        # Optional filtering
        if params[:start_date] && params[:end_date]
          @transactions = @transactions.for_date_range(params[:start_date], params[:end_date])
        end

        if params[:transaction_type]
          @transactions = @transactions.where(transaction_type: params[:transaction_type])
        end

        if params[:category_id]
          @transactions = @transactions.where(category_id: params[:category_id])
        end

        render json: @transactions.includes(:category, :account)
      end

      # GET /api/v1/transactions/:id
      def show
        render json: @transaction.as_json(include: [ :category, :account ])
      end

      # POST /api/v1/accounts/:account_id/transactions
      def create
        @transaction = @account.transactions.build(transaction_params)

        if @transaction.save
          render json: @transaction, status: :created
        else
          render json: { errors: @transaction.errors }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/transactions/:id
      def update
        if @transaction.update(transaction_params)
          render json: @transaction
        else
          render json: { errors: @transaction.errors }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/transactions/:id
      def destroy
        @transaction.destroy
        head :no_content
      end

      private

      def set_transaction
        @transaction = Transaction.joins(:account)
                                  .where(accounts: { user_id: current_user.id })
                                  .find(params[:id])
      end

      def set_account
        if params[:account_id]
          @account = current_user.accounts.find(params[:account_id])
        end
      end

      def transaction_params
        params.require(:transaction).permit(
          :amount, :transaction_type, :date, :description, :notes, :category_id, tags: []
        )
      end
    end
  end
end
