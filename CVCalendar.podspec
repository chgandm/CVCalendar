Pod::Spec.new do |s|

s.name = "CVCalendar"
s.version = "1.0.8-multiselect"
s.summary = "A custom visual calendar for iOS 8 written in Swift. Forked and podified to allow multi-select."
s.homepage = "https://github.com/Mozharovsky/CVCalendar"
s.license = "MIT"

s.authors = "Eugene Mozharovsky"
s.platforms = { :ios => "8.0" }

s.source = { :git => "https://github.com/chgandm/CVCalendar.git", :branch => "multiselect" }

s.source_files = "CVCalendar Demo/CVCalendar/*"
s.requires_arc = true

end