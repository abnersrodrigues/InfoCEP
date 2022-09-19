object InfoCepAPI: TInfoCepAPI
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  DisplayName = 'InfoCEP'
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 195
  Width = 227
end
