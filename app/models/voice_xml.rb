class VoiceXML
  attr_reader :message, :next_path, :expect

  def initialize(message:, next_path: nil, expect: nil)
    @message = message
    @next_path = next_path
    @expect = expect || ""
  end

  def to_xml(options = {})
    if next_path.present?
      continuing_xml
    else
      finishing_xml
    end
  end

  private

  def continuing_xml
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.gather action: next_path, input: "dtmf speech", hints: expect do |gather|
        gather.say message, voice: "alice", language: "en-US"
      end
    end

    response.to_s
  end

  def finishing_xml
    response = Twilio::TwiML::VoiceResponse.new do |response|
      response.say message, voice: "alice", language: "en-US"
      response.hangup
    end

    response.to_s
  end
end
