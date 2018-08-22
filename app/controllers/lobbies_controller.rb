class LobbiesController < ApplicationController

  #render a get for all lobbies
  def index
    lobbies = Lobby.all
    serialized_data = lobbies.map { |lobby|
      ActiveModelSerializers::Adapter::Json.new(
      LobbySerializer.new(lobby)
    )}
    render json: serialized_data
  end

  #create a new lobby
  def create
    #broadcasting out with lobby id so that the channel is unique
    lobby = Lobby.new(lobby_params)
    serialized_data = ""
    #the second argument here is what is passed via params
    if lobby.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(LobbySerializer.new(lobby))
    end

    render json: serialized_data
  end

  #used to update the lobby protection settings
  def update
    @lobby = Lobby.find(params[:id])
    @lobby.update_attributes(protected: params[:protected])
    render json: {protection: params[:protected]}
  end

  #Check to see if the lobby name is available amongst all of the lobby names
  def checkAvail
    lobbies = Lobby.all
    lobbyNames = lobbies.map do |lobby|
      lobby.name
    end
    avail = !lobbyNames.include?(params[:name])
    if avail
      render json: {availability: true}
    else
      render json: {availability: false}
    end
  end

  def joinLobby
    lobbies = Lobby.all
    lobby = lobbies.detect do |lobby|
      lobby.name == lobby_params[:name]
    end

    #user has correct name and password for lobby, let them in
    if lobby_params[:password] == lobby.password
      render json: {password_correct: true, lobby: lobby}
    #user does not have correct password
    else
      render json: {password_correct: false}
    end
  end

  def show
    lobby = Lobby.find(params[:id])
    serialized_data = ActiveModelSerializers::Adapter::Json.new(LobbySerializer.new(lobby))

    if lobby
      render json: {data: serialized_data}
    else
      render json: {response: "no lobby data"}
    end
  end

  def startGame
    @lobby = Lobby.find(lobby_params[:id])
    LobbiesChannel.broadcast_to(@lobby, {type: "START_GAME", startGame: true})
  end

  def pickMafia
    @lobby = Lobby.find(params[:lobby_id])
    @mafia = @lobby.users.find(params[:mafia_id])
    @mafia.update_attributes(role: "mafia")
    LobbiesChannel.broadcast_to(@lobby, {type: "mafia_selection", mafia: @mafia})
  end

  def mafiaExists
    @lobby = Lobby.find(params[:lobby_id])
    @users = @lobby.users
    mafiaExists = @users.any? do |user|
      user.role == "mafia"
    end
    render json: {response: mafiaExists}
  end

  def killVictim
    @lobby = Lobby.find(params[:lobby_id])
    @user = @lobby.users.find(params[:victim_id])
    LobbiesChannel.broadcast_to(@lobby, {type: "KILL", victim: @user, turn: params[:turn]})
    render json: {response: @user}
  end

  def castVote
    @lobby = Lobby.find(params[:lobby_id])
    @user = @lobby.users.find(params[:recipient_id])
    LobbiesChannel.broadcast_to(@lobby, {type: "CAST_VOTE", voter_id: params[:voter_id], recipient: @user})
  end

  def getRandomMafiaKillStory
    @lobby = Lobby.find(params[:lobby_id])
    kill_story = stories(params[:victim_username])
    LobbiesChannel.broadcast_to(@lobby, {type: "MAFIA_KILL_STORY", story: kill_story})
  end

  def disconnect
  end

  private

  def lobby_params
    params.require(:lobby).permit(:name, :password, :id, :protected)
  end

  def stories(victim)
    ["the mafioso cut #{victim}'s brakelines out", "#{victim} drank poisoned tea served to him by the mafioso 💊💊", "#{victim} was shot by the mafioso with his own 🔫", "☠️ #{victim} was Presumed dead of old age ☠️", "#{victim}'s flight to #{getRandomPlace} never landed, but the reason why is still unknown 🛫❌❌❌🛬", "#{victim} died peacefully in his sleep of a sledgehammer 🔨🔨"].sample
  end

  def getRandomPlace
    ["Afghanistan",
    "Aland Islands",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua And Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegowina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cape Verde",
    "Cayman Islands",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Cocos (Keeling) Islands",
    "Colombia",
    "Comoros",
    "Congo",
    "Congo, the Democratic Republic of the",
    "Cook Islands",
    "Costa Rica",
    "Cote d'Ivoire",
    "Croatia",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands (Malvinas)",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Guiana",
    "French Polynesia",
    "French Southern Territories",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Heard and McDonald Islands",
    "Holy See (Vatican City State)",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran, Islamic Republic of",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea, Democratic People's Republic of",
    "Korea, Republic of",
    "Kuwait",
    "Kyrgyzstan",
    "Lao People's Democratic Republic",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libyan Arab Jamahiriya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macao",
    "Macedonia, The Former Yugoslav Republic Of",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia, Federated States of",
    "Moldova, Republic of",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Niue",
    "Norfolk Island",
    "Northern Mariana Islands",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Palestinian Territory, Occupied",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russian Federation",
    "Rwanda",
    "Saint Barthelemy",
    "Saint Helena",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Pierre and Miquelon",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Georgia and the South Sandwich Islands",
    "Spain",
    "Sri Lanka",
    "Sudan",
    "Suriname",
    "Svalbard and Jan Mayen",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan, Province of China",
    "Tajikistan",
    "Tanzania, United Republic of",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States",
    "United States Minor Outlying Islands",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Venezuela",
    "Viet Nam",
    "Virgin Islands, British",
    "Virgin Islands, U.S.",
    "Wallis and Futuna",
    "Western Sahara",
    "Yemen",
    "Zambia",
    "Zimbabwe"].sample
  end
end
