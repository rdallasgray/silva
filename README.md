
How do I use it?
================

    gem install silva
    
    require 'silva'
    
    Silva::Location.from(:wgs84, :lat => 52.658008, :long => 1.716077).to(:gridref)

    "TG51411318"

What else can it do?
===================
Silva works with four different location systems:

- WGS84 
`(:wgs84, :lat => [latitude], :long => [longitude], :alt => [optional altitude])`
- OSGB36 
`(:osgb36, params as above)`
- EN 
`(:en, :easting => [easting], :northing => [northing])`
- GridRef 
`(:gridref, :gridref => [gridref] OR :easting => [easting], :northing => [northing])`

It can convert freely among each of them using the syntax `Silva::Location.from(:system, params).to(:system, params)`.

Why did you write it?
=====================
I needed to convert between WGS84 co-ordinates and Ordnance Survey grid references, and nothing out there quite did what I wanted (although see below). I'm also beginning with Ruby and wanted to get familiar with the idioms and best practices, so creating a gem seemed like a good way to do that.

Anything else?
=============
I began with code written by [Harry Wood](http://www.harrywood.co.uk/blog/2010/06/29/ruby-code-for-converting-to-uk-ordnance-survey-coordinate-systems-from-wgs84), who adapted code written by [Chris Veness](http://www.movable-type.co.uk/scripts/latlong-convert-coords.html). I subsequently went back over the maths to make sure I understood it reasonably well, and clarified it so that it's easy to check against the resources supplied by the Ordnance Survey. Some of Chris's and Harry's code is probably still lurking in there.

It should be accurate to about 5 to 10 metres.

Silva was written as part of my (MSc Project)[http://rdallsgray.github.com/archie-blog], of which more later.
