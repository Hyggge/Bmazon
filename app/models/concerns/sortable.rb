# frozen_string_literal: true

module Sortable
  extend ActiveSupport::Concern

  module ClassMethods
    def order_by(ordering_params)
      results = self.where(nil)
      ordering_params.each do |key, value|
        results = results.public_send("order_by_#{key}") if value.present?
      end
      results
    end
  end
end
