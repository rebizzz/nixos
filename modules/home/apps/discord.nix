{inputs, ...}: {
  flake.modules.homeManager.discord = {...}: {
    imports = [inputs.nixcord.homeModules.nixcord];

    programs.nixcord = {
      enable = true;
      discord = {
        branch = "canary";
        equicord.enable = true;
        krisp.enable = true;
        openASAR.enable = true;
      };

      config = {
        useQuickCss = true;
        disableMinSize = true;
        themeLinks = [
          "https://raw.githubusercontent.com/LuckFire/amoled-cord/343808e7d5297223e43868b3955da4cbbd01ceef/clients/amoled-cord.theme.css"
        ];
        enabledThemeLinks = [
          "https://raw.githubusercontent.com/LuckFire/amoled-cord/343808e7d5297223e43868b3955da4cbbd01ceef/clients/amoled-cord.theme.css"
        ];

        plugins = {
          # UI / QoL
          accountPanelServerProfile.enable = true;
          advancedPermissions.enable = true;
          alwaysExpandProfiles.enable = true;
          alwaysTrust.enable = true;
          anonymiseFileNames.enable = true;
          autoZipper.enable = true;
          betterActivities.enable = true;
          betterBanReasons.enable = true;
          betterForwards.enable = true;
          betterInvites.enable = true;
          betterRoleContext.enable = true;
          betterSessions.enable = true;
          betterSettings.enable = true;
          betterUploadButton.enable = true;
          biggerStreamPreview.enable = true;
          bypassPinPrompt.enable = true;
          callTimer.enable = true;
          clickableRoles.enable = true;
          clipsEnhancements.enable = true;
          clipUpload.enable = true;
          clearUrls.enable = true;
          collapsibleUi.enable = true;
          copyFileContents.enable = true;
          copyStatusUrls.enable = true;
          copyUserMention.enable = true;
          crashHandler.enable = true;
          downloadAllAttachments.enable = true;
          expressionCloner.enable = true;
          fakeNitro.enable = true;
          findReply.enable = true;
          fixImagesQuality.enable = true;
          forceOwnerCrown.enable = true;
          fullVcpfp.enable = true;
          iLoveSpam.enable = true;
          imageFilename.enable = true;
          imageZoom.enable = true;
          implicitRelationships.enable = true;
          iRememberYou.enable = true;
          limitlessScreenshare.enable = true;
          memberCount.enable = true;
          messageClickActions.enable = true;
          messageLogger.enable = true;
          messageLoggerEnhanced.enable = true;
          mutualGroupDms.enable = true;
          noNitroUpsell.enable = true;
          normalizeMessageLinks.enable = true;
          noTrack.enable = true;
          noTypingAnimation.enable = true;
          onePingPerDm.enable = true;
          permissionsViewer.enable = true;
          platformIndicators.enable = true;
          readAllNotificationsButton.enable = true;
          relationshipNotifier.enable = true;
          serverInfo.enable = true;
          showAllMessageButtons.enable = true;
          showHiddenChannels.enable = true;
          showHiddenThings.enable = true;
          showSongName.enable = true;
          showTimeoutDuration.enable = true;
          silentTyping.enable = true;
          sortFriends.enable = true;
          summaries.enable = true;
          timezones.enable = true;
          typingTweaks.enable = true;
          universalMention.enable = true;
          unlockedAvatarZoom.enable = true;
          userVoiceShow.enable = true;
          validReply.enable = true;
          validUser.enable = true;
          vcPanelSettings.enable = true;
          viewIcons.enable = true;
          voiceChatDoubleClick.enable = true;
          voiceDownload.enable = true;
          voiceStats.enable = true;
          volumeBooster.enable = true;
          whoReacted.enable = true;
          whosWatching.enable = true;
          zipPreview.enable = true;
        };
      };
    };
  };
}
