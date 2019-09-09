class UnlockedMainsController < ApplicationController
  skip_before_action :authenticate_team!

  def new
    #FIXME: this should probably be in some global defines
    main_puzzle_prize = 145
    if current_team.points < main_puzzle_prize
      flash[:alert] = "Nemáte dostatek OCoinů, je potřeba %i a máte jen %i" % [main_puzzle_prize, current_team.points]
      redirect_to pruchod_hlavni_path
      return
    end

    #find all locked main puzzles
    main_puzzles = Puzzle.where(puztype: 'main')

    # this code is stupid and can be probably writen is a single line
    # however ATM its easier for me to write it this way than google for the right way
    locked_mains = []
    main_puzzles.each do |mp|
      locked = true
      current_team.unlocked_mains.each do |um|
        if um
          if um.puzzle.name == mp.name
            locked = false
          end
        end
      end
      if locked
        locked_mains << mp
      end
    end

    # now select one at random
    # maybe just pick in order, the previous code could be simplified than
    puzzle = locked_mains.sample
    main = UnlockedMain.new(team: current_team, puzzle: puzzle)

    if locked_mains.count == 0
      flash[:alert] = "Už máte odkryté všechny hlavní šifry"
      redirect_to pruchod_hlavni_path
    elsif main.save
      flash[:success] = "Šifra %s úspěšně odkryta" % puzzle.name

      ot = OcoinTransaction.new(team: current_team, points: -main_puzzle_prize,
                              message: 'Odkrytí polohy hlavní šifry %s' % puzzle.name)
      ot.save

      current_team.points -= main_puzzle_prize
      current_team.save

      redirect_to puzzles_path
    else
      flash[:alert] = "Selhalo"
      redirect_to pruchod_hlavni_path
    end
  end
end
