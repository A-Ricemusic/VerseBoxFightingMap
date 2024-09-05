
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Playspaces }
using { /Fortnite.com/Teams }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
game_manager_device := class(creative_device):

    @editable       TeamSelectionRed : class_and_team_selector_device  = class_and_team_selector_device {}
    @editable       TeamSelectionBlue : class_and_team_selector_device  = class_and_team_selector_device {}
    @editable       TeamSelectionSpectate : class_and_team_selector_device  = class_and_team_selector_device {}
    @editable       BarrierTimer : timer_device = timer_device{}    
    @editable       BarrierRed : barrier_device = barrier_device{}
    @editable       BarrierBlue : barrier_device = barrier_device{}
    @editable       GameStartButton : button_device = button_device{}
    @editable       TeleporterRed : teleporter_device = teleporter_device{}
    @editable       TeleporterBlue : teleporter_device = teleporter_device{}
    @editable       MutatorZoneGame : mutator_zone_device = mutator_zone_device{}
    @editable       ItemGrantor : item_granter_device = item_granter_device{}
    @editable       RoundSettings : round_settings_device = round_settings_device{}
    @editable       StormController: advanced_storm_controller_device = advanced_storm_controller_device{}
    @editable       DamageVolume : damage_volume_device = damage_volume_device{}
    @editable       TriggerLeftRed : trigger_device = trigger_device{}
    @editable       TriggerRightRed : trigger_device = trigger_device{}
    @editable       TriggerLeftBlue : trigger_device = trigger_device{}
    @editable       TriggerRightBlue : trigger_device = trigger_device{}
    @editable       TeleporterLeftRed : teleporter_device = teleporter_device{}
    @editable       TeleporterRightRed : teleporter_device = teleporter_device{}
    @editable       TeleporterLeftBlue : teleporter_device = teleporter_device{}
    @editable       TeleporterRightBlue : teleporter_device = teleporter_device{}
    @editable       PlayerCounterRed : player_counter_device = player_counter_device{}
    @editable       PlayerCounterBlue : player_counter_device = player_counter_device{}



    OnBegin<override>()<suspends>:void=
        Players := GetPlayspace().GetPlayers()
        MutatorZoneGame.AgentEntersEvent.Subscribe(OnPlayerEntered)
        BarrierTimer.SuccessEvent.Subscribe(OnTimerEnded)
        RoundSettings.RoundBeginEvent.Subscribe(OnRoundStart)
        GameStartButton.InteractedWithEvent.Subscribe(OnGameStartButtonPressed)
        TriggerLeftRed.TriggeredEvent.Subscribe(OnTriggerLeftRed)
        TriggerRightRed.TriggeredEvent.Subscribe(OnTriggerRightRed)
        TriggerLeftBlue.TriggeredEvent.Subscribe(OnTriggerLeftBlue)
        TriggerRightBlue.TriggeredEvent.Subscribe(OnTriggerRightBlue)
        for (plr : Players):
            ItemGrantor.GrantItem(plr)
            ItemGrantor.RestockItems()

    

    
    OnTriggerLeftRed(Agent: ?agent) : void =
        if (ValidAgent := Agent?):
            TeleporterLeftRed.Teleport(ValidAgent)
            TeleporterLeftRed.Disable()
            TriggerLeftRed.Disable()

        
    OnTriggerRightRed(Agent : ?agent) : void =
        if (ValidAgent := Agent?):
            TeleporterRightRed.Teleport(ValidAgent)
            TeleporterRightRed.Disable()
            TriggerRightRed.Disable()
    
    OnTriggerLeftBlue(Agent : ?agent) : void =
        if (ValidAgent := Agent?):
            TeleporterLeftBlue.Teleport(ValidAgent)
            TeleporterLeftBlue.Disable()
            TriggerLeftBlue.Disable()
            
            
            
        
    OnTriggerRightBlue(Agent : ?agent) : void =
        if (ValidAgent := Agent?):
            TeleporterRightBlue.Teleport(ValidAgent)
            TeleporterRightBlue.Disable()
            TriggerRightBlue.Disable()
        


    

    OnGameStartButtonPressed(Agent : agent) : void =
        
        Players := GetPlayspace().GetPlayers()
        TeamCollection := GetPlayspace().GetTeamCollection()


        for (plr : Players):
            Print("Teleporting Players")
            if:
                Team := TeamCollection.GetTeam[plr]
                Print("Team Found")
            then:
                if (Team = TeamCollection.GetTeams()[8]):
                    TeleporterRed.Teleport(plr)
                    Print("Player Teleported Red")
                if (Team = TeamCollection.GetTeams()[9]):
                    TeleporterBlue.Teleport(plr)
                    Print("Player Teleported Blue")
                Print("no team matches")
        TeleporterRed.Disable()
        TeleporterBlue.Disable()
        DamageVolume.Enable()

             

    

    OnPlayerEntered(Agent : agent) : void =
        Print("Player Entered Mutator Zone")
        BarrierTimer.Start()
        DamageVolume.Enable()
        
    
    
    OnTimerEnded(Agent : ?agent) : void =
        BarrierBlue.Disable()
        BarrierRed.Disable()
        StormController.GenerateStorm()
        
    OnRoundStart() : void =
        BarrierBlue.Enable()
        BarrierRed.Enable()
        TeleporterLeftRed.Enable()
        TeleporterLeftBlue.Enable()
        TeleporterRightRed.Enable()
        TeleporterRightBlue.Enable()
        TriggerLeftRed.Enable()
        TriggerRightRed.Enable()
        TriggerLeftBlue.Enable()
        TriggerRightBlue.Enable()
    
