Gem::Specification.new do |s|
  s.name        = 'rudux'
  s.version     = '0.0.3'
  s.date        = '2016-12-13',
  s.summary     = "Redux like state management in OO Ruby"
  s.description = "Redux like state management in OO Ruby"
  s.authors     = ["Christopher Okhravi"]
  s.files       = [
    "lib/rudux/action.rb",
    "lib/rudux/combined.rb",
    "lib/rudux/entity.rb",
    "lib/rudux/mutating_reducer.rb",
    "lib/rudux/reducer.rb",
    "lib/rudux/store.rb",
  ]
  s.homepage    =
    'https://github.com/chrokh/rudux'
  s.license       = 'MIT'
end
