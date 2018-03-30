class Voice::VerificationsController < Voice::ApplicationController
  def new
    prefix = params[:prefix] || ""
    message = "#{prefix} Are we speaking with #{party.name}?"

    render xml: VoiceXML.new(
      message: message,
      next_path: voice_session_verifications_path(party)
    )
  end

  def create
    input = VoiceInput.new(voice_params)

    if input.affirmative?
      session[:current_party_id] = party.id
      redirect_to new_voice_party_response_path(venue: "patterson_park")
    elsif input.negative?
      redirect_to new_voice_session_path(prefix: "Hmm, sorry about that.")
    else
      redirect_to new_voice_session_verification_path(
        Current.party,
        prefix: "Sorry, I didn't understand you."
      )
    end
  end

  private

  def voice_params
    params.slice("Digits", "SpeechResult", "Confidence").permit!
  end

  def party
    @party ||= Party.find(params[:session_id])
  end
end
