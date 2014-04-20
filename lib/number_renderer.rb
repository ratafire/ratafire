class NumberRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected

    def pagination
      items = @options[:page_links] ? windowed_page_numbers : []
      items.push :previous_page, :next_page
    end


end