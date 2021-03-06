class Voice::SessionsController < Voice::ApplicationController
  include Voiceable

  def new
    prefix = params[:prefix] || translate(".intro")

    render xml: VoiceXML.new(
      message: translate(".message", prefix: prefix),
      next_path: voice_sessions_path,
      expect: (1..100).to_a.join(",")
    )
  end

  def create
    party = Party.find_by(reservation_code: voice_input.to_s.delete(" "))

    if party
      session[:current_party_id] = party.id
      redirect_to new_voice_session_verification_path
    else
      redirect_to new_voice_session_path(prefix: translate(".error"))
    end
  end
end
