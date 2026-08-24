{inputs, ...}: {
  flake.modules.homeManager.discord = {...}: {
    imports = [inputs.nixcord.homeModules.nixcord];

    programs.nixcord = {
      enable = true;
      vesktop.enable = true;

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
          accountPanelServerProfile.enable = true;
          alwaysTrust.enable = true;
          anonymiseFileNames.enable = true;
          betterRoleContext.enable = true;
          betterSessions.enable = true;
          betterSettings.enable = true;
          betterUploadButton.enable = true;
          biggerStreamPreview.enable = true;
          callTimer.enable = true;
          clearUrls.enable = true;
          copyFileContents.enable = true;
          crashHandler.enable = true;
          expressionCloner.enable = true;
          fakeNitro.enable = true;
          fixImagesQuality.enable = true;
          forceOwnerCrown.enable = true;
          iLoveSpam.enable = true;
          imageFilename.enable = true;
          imageZoom.enable = true;
          implicitRelationships.enable = true;
          memberCount = {
            enable = true;
            voiceActivity = false;
          };
          messageClickActions.enable = true;
          mutualGroupDms.enable = true;
          noTrack.enable = true;
          noTypingAnimation.enable = true;
          onePingPerDm.enable = true;
          permissionsViewer.enable = true;
          platformIndicators = {
            enable = true;
            list = false;
            messages = false;
          };
          readAllNotificationsButton.enable = true;
          relationshipNotifier.enable = true;
          serverInfo.enable = true;
          showAllMessageButtons.enable = true;
          showHiddenChannels.enable = true;
          showHiddenThings.enable = true;
          showTimeoutDuration.enable = true;
          silentTyping.enable = true;
          summaries.enable = true;
          typingTweaks.enable = true;
          unlockedAvatarZoom.enable = true;
          userVoiceShow = {
            enable = true;
            showInMemberList = false;
            showInMessages = true;
          };
          validReply.enable = true;
          validUser.enable = true;
          viewIcons.enable = true;
          voiceChatDoubleClick.enable = true;
          voiceDownload.enable = true;
          volumeBooster.enable = true;
          whoReacted.enable = true;
        };
      };
    };
  };
}
