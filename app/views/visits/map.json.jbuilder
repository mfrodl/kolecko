json.puzzles @open_puzzles do |puzzle|
  json.latitude puzzle.latitude
  json.longitude puzzle.longitude
  json.visited @visited_puzzles.include? puzzle
  json.solved @solved_puzzles.include? puzzle
end
