if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    const baseElement = document.querySelector("base");
    const baseUrl = new URL(baseElement?.href ?? "/", window.location.href);
    const workerUrl = new URL("sw.js", baseUrl);
    navigator.serviceWorker
      .register(workerUrl, { scope: baseUrl.pathname })
      .catch((error) => console.error("Bipolaris PWA registration failed", error));
  });
}
