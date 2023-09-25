class VendorsController < ApplicationController
  def index
    @vendors = Vendor.all
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to vendors_path, notice: "Vendor created successfully"
    else
      render "new"
    end
  end

  def edit
    vendor
  end

  def update
    if vendor.update(vendor_params)
      redirect_to vendors_path, notice: "Vendor is updated"
    else
      render "edit"
    end
  end

  def destroy
    @vendor = vendor
    if @vendor.destroy
      flash[:notice] = "Vendor deleted successfully"
    else
      flash[:error] = @vendor.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: vendors_path)
  end

  private

  def vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(:name, :street, :street2, :city, :state, :country, :gst_no, :pan_no)
  end
end
