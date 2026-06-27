{{flutter_js}}
{{flutter_build_config}}

(function () {
  const boot = window.__plugseloBoot;
  const setMessage = (message, isError = false) => {
    if (boot && typeof boot.setMessage === 'function') {
      boot.setMessage(message, isError);
    }
  };

  setMessage('Carregando engine Flutter...');

  _flutter.loader
    .load({
      onEntrypointLoaded: async function (engineInitializer) {
        setMessage('Inicializando engine...');
        const appRunner = await engineInitializer.initializeEngine();
        setMessage('Abrindo app...');
        await appRunner.runApp();
        if (boot && typeof boot.complete === 'function') {
          boot.complete();
        }
      },
    })
    .catch(function (error) {
      const details = error && (error.stack || error.message || error);
      setMessage('Nao foi possivel iniciar o Flutter:\\n' + details, true);
      console.error(error);
    });
})();
