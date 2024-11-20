@echo --------------------------------------------------------------------------- 
@echo ******************* AGREGAR POOL DE APLICACIONES *******************
@echo ******** USTED VA AGREGAR EL POOL DE APLICACIONES Y EL RECURSO VIRTUAL **************
@echo ** POR FAVOR VERIFICAR LAS RUTAS SI ESTAS ESTAN LIGADAS AL SITIO WEB QUE DESEA CONFIGURAR **
@echo ___________________________________________________________________________
@echo               ===============================================
@echo **************          A D D - P O O L - I I S             **************
@echo               ===============================================
@echo               ===============================================
@echo **************   A D D -  V I R T U A L - R E S O U R C E    **************
@echo               ===============================================


@REM AGREGAR EN LA VARIABLE DE SISTEMA, PATH DE WINDOWS AGREGAR LA RUTA 'C:\Windows\System32\inetsrv\'

appcmd add app /site.name:"nameSiteWeb" /path:"/GestionCapitalHumano.Api" /physicalPath:"C:\inetpub\nameSiteWeb\GestionCapitalHumano.Api" /applicationPool:"nameSiteWeb.GestionCapitalHumano" && appcmd add apppool /apppool.name:nameSiteWeb.GestionCapitalHumano /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/GestionCapitalHumano.api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"nameSiteWeb" /path:"/Encuestas.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Encuestas.Api" /applicationPool:"nameSiteWeb.Encuestas" && appcmd add apppool /apppool.name:nameSiteWeb.Encuestas /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Encuestas.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/GestionContenidos.Api" /physicalPath:"C:\inetpub\nameSiteWeb\GestionContenidos.Api" /applicationPool:"nameSiteWeb.GestionContenidos" && appcmd add apppool /apppool.name:nameSiteWeb.GestionContenidos /processModel.identityType:"LocalSystem"  && appcmd add vdir /app.name:nameSiteWeb/GestionContenidos.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"nameSiteWeb" /path:"/ActivosFijos.Api" /physicalPath:"C:\inetpub\nameSiteWeb\ActivosFijos.Api" /applicationPool:"nameSiteWeb.ActivosFijos" && appcmd add apppool /apppool.name:nameSiteWeb.ActivosFijos /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/ActivosFijos.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt

appcmd add app /site.name:"nameSiteWeb" /path:"/Admin.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Admin.Api" /applicationPool:"nameSiteWeb.Admin" && appcmd add apppool /apppool.name:nameSiteWeb.Admin /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Admin.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"nameSiteWeb" /path:"/ComprasInventarios.Api" /physicalPath:"C:\inetpub\nameSiteWeb\ComprasInventarios.Api" /applicationPool:"nameSiteWeb.ComprasInventarios" && appcmd add apppool /apppool.name:nameSiteWeb.ComprasInventarios /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/ComprasInventarios.api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt


appcmd add app /site.name:"nameSiteWeb" /path:"/CuentasPorCobrar.Api" /physicalPath:"C:\inetpub\nameSiteWeb\CuentasPorCobrar.Api" /applicationPool:"nameSiteWeb.CuentasPorCobrar" && appcmd add apppool /apppool.name:nameSiteWeb.CuentasPorCobrar /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/CuentasPorCobrar.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/CuentasPorPagar.Api" /physicalPath:"C:\inetpub\nameSiteWeb\CuentasPorPagar.Api" /applicationPool:"nameSiteWeb.CuentasPorPagar" && appcmd add apppool /apppool.name:nameSiteWeb.CuentasPorPagar /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/CuentasPorPagar.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/EntregaMasivaDocumentos.Api" /physicalPath:"C:\inetpub\nameSiteWeb\EntregaMasivaDocumentos.Api" /applicationPool:"nameSiteWeb.EntregaMasivaDocumentos" && appcmd add apppool /apppool.name:nameSiteWeb.EntregaMasivaDocumentos  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/EntregaMasivaDocumentos.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/FacturacionPeriodica.Api" /physicalPath:"C:\inetpub\nameSiteWeb\FacturacionPeriodica.Api" /applicationPool:"nameSiteWeb.FacturacionPeriodica" && appcmd add apppool /apppool.name:nameSiteWeb.FacturacionPeriodica  /processModel.identityType:"LocalSystem" & appcmd add vdir /app.name:nameSiteWeb/FacturacionPeriodica.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/Financiero.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Financiero.Api" /applicationPool:"nameSiteWeb.Financiero" && appcmd add apppool /apppool.name:nameSiteWeb.Financiero /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Financiero.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/GestionTrabajo.Api" /physicalPath:"C:\inetpub\nameSiteWeb\GestionTrabajo.Api" /applicationPool:"nameSiteWeb.GestionTrabajo" &&appcmd add apppool /apppool.name:nameSiteWeb.GestionTrabajo  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/GestionTrabajo.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/Interfaces.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Interfaces.Api" /applicationPool:"nameSiteWeb.Interfaces" && appcmd add apppool /apppool.name:nameSiteWeb.Interfaces /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Interfaces.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 



appcmd add app /site.name:"nameSiteWeb" /path:"/Logistica.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Logistica.Api" /applicationPool:"nameSiteWeb.Logistica" && appcmd add apppool /apppool.name:nameSiteWeb.Logistica  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Logistica.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/MantenimientoMaquinaria.Api" /physicalPath:"C:\inetpub\nameSiteWeb\MantenimientoMaquinaria.Api" /applicationPool:"nameSiteWeb.MantenimientoMaquinaria" && appcmd add apppool /apppool.name:nameSiteWeb.MantenimientoMaquinaria  /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/MantenimientoMaquinaria.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/Salud.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Salud.Api" /applicationPool:"nameSiteWeb.Salud" && appcmd add apppool /apppool.name:nameSiteWeb.Salud /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Salud.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/Security.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Security.Api" /applicationPool:"nameSiteWeb.Security" && appcmd add apppool /apppool.name:nameSiteWeb.Security /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Security.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/TablasSistema.Api" /physicalPath:"C:\inetpub\nameSiteWeb\TablasSistema.Api" /applicationPool:"nameSiteWeb.TablasSistema" && appcmd add apppool /apppool.name:nameSiteWeb.TablasSistema /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/TablasSistema.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 


appcmd add app /site.name:"nameSiteWeb" /path:"/Ventas.Api" /physicalPath:"C:\inetpub\nameSiteWeb\Ventas.Api" /applicationPool:"nameSiteWeb.Ventas" && appcmd add apppool /apppool.name:nameSiteWeb.Ventas /processModel.identityType:"LocalSystem" && appcmd add vdir /app.name:nameSiteWeb/Ventas.Api /path:/recursos /physicalPath:E:\Apps\nameSiteWeb /username:small /password:123456Aa >> salida.txt 




