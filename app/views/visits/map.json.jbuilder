json.puzzles @puzzles do |puzzle|
  json.latitude puzzle.latitude
  json.longitude puzzle.longitude
  json.final @final_puzzles.include? puzzle
  json.main @main_puzzles.include? puzzle
  json.visited @visited_puzzles.include? puzzle
  json.solved @solved_puzzles.include? puzzle
end
