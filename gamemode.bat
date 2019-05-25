@echo off
if /I "%1" == "" goto usage
if /I "%1" == "start" goto start
if /I "%1" == "stop" goto stop
if /I "%1" == "setup" goto setup
goto usage

@rem #############
@rem ### Start ###
@rem #############
:start
echo Starting game mode.

@rem Adobe Apps
taskkill /F /IM "Adobe Desktop Service.exe"
taskkill /F /IM "Creative Cloud.exe"
taskkill /F /IM AdobeIPCBroker.exe
taskkill /F /IM CCLibrary.exe
taskkill /F /IM CCXProcess.exe
taskkill /F /IM CoreSync.exe
taskkill /F /IM reader_sl.exe
taskkill /F /IM acrotray.exe

@rem Windows Apps
@rem taskkill /F /IM HxTsr.exe
taskkill /F /IM HxCalendarAppImm.exe
taskkill /F /IM HxOutlook.exe
taskkill /F /IM Maps.exe
taskkill /F /IM MessagingApplication.exe
taskkill /F /IM Microsoft.Photos.exe
taskkill /F /IM Music.UI.exe
taskkill /F /IM SystemSettings.exe
taskkill /F /IM Video.UI.exe
taskkill /F /IM WinStore.App.exe
taskkill /F /IM XboxApp.exe

@rem Apple Apps
taskkill /F /IM distnoted.exe
taskkill /F /IM AppleMobileDeviceProcess.exe

@rem Everything else
taskkill /F /IM 1Password.exe
taskkill /F /IM Agile1pAgent.exe
taskkill /F /IM unsecapp.exe
taskkill /F /IM updaterstartuputility.exe

@rem Services
net stop "AdobeARMservice"
net stop "AdobeUpdateService"
net stop "AGSService"
net stop "AGMService"
net stop "Apple Mobile Device Service"
net stop "BcastDVRUserService"
net stop "Cisco AnyConnect Secure Mobility Agent"
net stop "ICCS"
net stop "Intel(R) Content Protection HDCP Service"
net stop "Intel(R) Content Protection HECI Service"
net stop "iPod Service"
net stop "LightingService"
net stop "Razer Game Scanner Service"
net stop "sedsvc"
net stop "WaaSMedicSvc"
net stop "XblAuthManager" 
net stop "XblGameSave" 
net stop "XboxNetApiSvc" 

@rem Services to start in gaming mode
@rem net start "Tobii Service"

@rem Activate the High Performance power plan
powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
goto end

@rem ############
@rem ### Stop ###
@rem ############
:stop
echo Stopping game mode.

@rem Services
net start "iPod Service"
net start "Apple Mobile Device Service"
net start "LightingService"

@rem Services to stop when leaving gaming mode
net stop "Tobii Service"

@rem Restore the Balanced power plan.
powercfg.exe /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
goto end

@rem #############
@rem ### Setup ###
@rem #############
:setup
echo Setting up services.
sc config "AdobeARMservice" start= disabled
sc config "AdobeUpdateService" start= demand
sc config "AGSService" start= disabled
sc config "AGMService" start= disabled
sc config "Apple Mobile Device Service" start= demand
sc config "asComSvc" start= auto
sc config "asHmComSvc" start= auto
sc config "AsSysCtrlService" start= auto
sc config "AsusFanControlService" start= auto
sc config "BcastDVRUserService" start= disabled 
sc config "BcmBtRSupport" start= auto
sc config "Bonjour Service" start= disabled
sc config "GalaxyClientService" start= disabled
sc config "GalaxyCommunication" start= disabled
sc config "gupdate" start= disabled
sc config "gupdatem" start= disabled
sc config "ICCS" start= demand
sc config "iPod Service" start= demand
sc config "LightingService" start= auto
sc config "NMSAccess" start= disabled
sc config "NVDisplay.ContainerLocalSystem" start= auto
sc config "NvTelemetryContainer" start= auto
sc config "Origin Client Service" start= demand
sc config "Origin Web Helper Service" start= auto
sc config "OverwolfUpdater" start= demand
sc config "Razer Chroma SDK Server" start= disabled
sc config "Razer Chroma SDK Service" start= disabled
sc config "Razer Game Scanner Service" start= disabled
@rem Windows Remediation Service
sc config "sedsvc" start= disabled  
sc config "Steam Client Service" start= demand
sc config "Tobii Service" start= demand
@rem Windows Update Medic Service
@rem Will probably return "Access Denied". Find a way to disable this.
@rem sc config "WaaSMedicSvc" start= disabled
sc config "XblAuthManager" start= disabled
sc config "XblGameSave" start= disabled
sc config "XboxNetApiSvc" start= disabled
sc config "XTU3SERVICE" start= delayed-auto

@rem Disable wake armed devices
for /F "tokens=*" %%A in ('powercfg -devicequery wake_armed') do (
  if not "%%A"=="NONE" (
    echo Disabling %%A
    powercfg -devicedisablewake "%%A"
  )
)
goto end

@rem #############
@rem ### Usage ###
@rem #############
:usage
echo gamemode start ^| stop ^| setup
goto end

@rem ###########
@rem ### End ###
@rem ###########
:end
timeout 3
@rem pause
exit