module ControllerParams
  private
    def answer_params
      params.require(:answer).permit(:text)
    end

    def hint_request_params
      params.require(:hint_request).permit(:note, :bounty)
    end

    def hint_params
      params.require(:hint).permit(:text, :rating, :hint_request_id)
    end

    def message_params
      params.require(:message).permit(:text)
    end

    def puzzle_params
      params.require(:puzzle).permit(:code)
    end

    def team_params
      params.require(:team).permit(
        :name, :phone, :password, :phone, :player1_name, :player1_email,
        :player2_name, :player2_email, :player3_name, :player3_email,
        :player4_name, :player4_name
      )
    end
end
