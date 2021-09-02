=begin
    Pass a codepen id to this filter to produce an embedded iframe for the page.

    I have a habit of frequently changing the name or contents of my pens
    so rebuilding this in a consistent way should help keep them up to date.

    This also centralises the embed code for codepen so any updates to the iframe
    structure only have to get made in one place over updating many iframes in my
    posts.

    Usage {{ penID | embed_codepen }}
=end
module Jekyll
    module ExperimentEmbed
        def embed_codepen(input)
            result = "<iframe " \
                "height='400' " \
                "style='width: 100%;' " \
                "scrolling='no' " \
                "src='https://codepen.io/dayvidwhy/embed/#{input}?default-tab=result' " \
                "frameborder='no' " \
                "loading='lazy' " \
                "allowtransparency='true' " \
                "allowfullscreen='true'> " \
                "<a href='https://codepen.io/dayvidwhy/pen/#{input}'>See the Pen</a> by David Young (<a href='https://codepen.io/dayvidwhy'>@dayvidwhy</a>) " \
                "on <a href='https://codepen.io'>CodePen</a>. " \
            "</iframe>"
            result
        end
    end
end

Liquid::Template.register_filter(Jekyll::ExperimentEmbed);
