class Api::V1::ProductsController < ApplicationController
  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def find_by_category
    @products_list = Product.where(product_params[:category])

    if @products_list
      render json: @products_list, status: :accepted
    else
      render json: {error: 'Categoria não encontrada'}, status: :not_found
    end
  end

  def update
    return render json: {error: @error[:msg]}, status: @error[:status] unless product_parms_is_valid?
    if @product.update(product_params)
      render json: @product, status: :accepted
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def remove_product_from_catalog
    return render json: {error: @error[:msg]}, status: @error[:status] unless product_parms_is_valid?
    @product.destroy!
    render json: {msg: 'Prouto removido'}, status: :accepted
  end

  private

  def product_parms_is_valid?
    @product = Product.find_by(name: product_params[:name])
    @error = {msg: 'Produto inexistente', status: :not_found}
    return false unless @product

    true
  end

  def product_params
     params.permit(:name, :category, :description, :price, :quantity, :images, :product_id)
  end
end