class BillsController < ApplicationController
  require "csv"

  def index
    @month        = params[:month] || nil
    @year         = params[:year] || Time.zone.today.year
    params[:q] ||= {}
    @searcher    = Bill.ransack(params[:q])

    @bills = Bill.filter_month_year(@searcher, @month, @year)

    respond_to do |format|
      format.html
      format.csv do
        filename = @month ? "Bills_Statement_#{@month}_#{@year}" : "Bills_Statement_#{@year}"
        send_data Bill.to_csv(@bills), disposition: "attachment;", filename: "#{filename}.csv", content_type: "text/csv"
      end
    end
    @pagy, @bills = pagy(@bills)
  end

  def show
    bill
    @pagy, @bill_items = pagy(bill.bill_items.all)
  end

  def new
      @bill = Bill.new
          @bill.bill_items.build
  end

  def create
    @bill = Bill.new(bill_params)

    if @bill.save

      redirect_to bills_path, notice: "Bill is created successfully"
    else
      render "new"

    end
  end

  def edit
    bill
  end

  def update
      if bill.update(bill_params)
      redirect_to bills_path, notice: "Bill is updated successfully"
      else
      render "edit"
      end
  end

  def destroy
    @bill = bill
    if @bill.destroy
      flash[:notice] = "Bill deleted successfully"
    else
      flash[:error] = @bill.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: bills_path)
  end

  private

  def bill
    @bill ||= Bill.find(params[:id])
  end

  def bill_params
    params.require(:bill).permit(
      :ref_no, :date, :total_cgst, :total_sgst, :total_igst, :total_amount, :vendor_id, :document, :is_gst,
      bill_items_attributes: [
        :id, :bill_id, :product, :hsn_code, :amount_before_tax, :cgst, :sgst, :igst, :amount, :_destroy
      ]
    )
  end
end
