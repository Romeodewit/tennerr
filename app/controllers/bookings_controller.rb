class BookingsController < ApplicationController
  before_action :find_booking, only: [:show, :edit, :update, :cancel, :accept]
  before_action :find_service, only: [:create]
  before_action :find_user, only: [:create, :index]

  def index
    @inward_bookings = current_user.incoming_bookings
    @outward_bookings = current_user.bookings
  end

  def show
    @service = @booking.service
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = @user
    @booking.service = @service
    @booking.date = Date.today
    @booking.status = "Pending"
    if @booking.save!
      redirect_to booking_path(@booking)
    else
      render '/services/show'
    end
  end

  def edit
    @service = @booking.service
  end

  def update
    @service = @booking.service
    if @booking.update(booking_params)
      redirect_to booking_path(@booking)
    else
      render :edit
    end
  end

  def cancel
    @booking.status = "Decline"
    @booking.save
    redirect_to booking_path(@booking)
  end

  def accept
    @booking.status = "Accept"
    @booking.save
    redirect_to booking_path(@booking)
  end

  private

  def find_user
    @user = current_user
  end

  def find_booking
    @booking = Booking.find(params[:id])
  end

  def find_service
    @service = Service.find(params[:service_id])
  end

  def booking_params
    params.require(:booking).permit(:deadline)
  end
end
