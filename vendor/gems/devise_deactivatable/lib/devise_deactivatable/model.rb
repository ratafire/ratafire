module Devise
  module Models
    module Deactivatable

      def active_for_authentication?
        !deactivated? && super
      end

      def deactivate!
        self.deactivated_at = Time.now
        save(:validate => false)
      end

      def reactivate!
        self.deactivated_at = nil
        save(:validate => false)
      end

      def deactivated?
        !!deactivated_at
      end

      def inactive_message
        deactivated? ? :deactivated : super
      end

    end
  end
end
