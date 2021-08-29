=begin
    Configurable feedback to users for how long it would take
    to read the contents of a page by splitting on each word
    and considers a 'words_per_minute' rate.
    Usage {{ page.content | time_to_read }}
=end
module Jekyll
    module TimeToReadFilter
        def time_to_read(input)
            # reading rate
            words_per_minute = 180

            # produce feedback on reading time
            words = input.split.size;
            minutes = (words / words_per_minute).floor;
            minutes_label = minutes === 1 ? " minute" : " minutes";
            minutes > 0 ? "about #{minutes} #{minutes_label}" : "less than 1 minute";
        end
    end
end

Liquid::Template.register_filter(Jekyll::TimeToReadFilter);
