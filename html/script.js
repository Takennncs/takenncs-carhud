document.addEventListener("DOMContentLoaded", function () {
  
  const elements = {
    mybody: document.getElementById("mybody"),
    belt: document.getElementById("kemer"),
    speedText: document.getElementById("kmtext"),
    fuelProgress: document.getElementById("fuel-progress"),
  };

  window.addEventListener("message", function (event) {
    const data = event.data;
    if (!data || !data.message) return;

    switch (data.message) {
      case "vehicleHud":
        if (elements.mybody) {
          elements.mybody.style.display = data.hudActive ? "block" : "none";
        }
        break;

      case "beltToggle":
        if (elements.belt) {
          elements.belt.style.color = data.BeltActive ? "#ffce00" : "white";
        }
        break;

      case "vehicleUpdate":
        if (elements.speedText) {
          const speed = Math.floor(data.vehicleSpeed || 0);
          let speedText = speed < 10 ? "00" + speed : (speed < 100 ? "0" + speed : speed.toString());
          elements.speedText.textContent = speedText;
        }

        if (elements.fuelProgress && typeof data.vehicleFuel === "number") {
          const percent = Math.max(0, Math.min(data.vehicleFuel, 100));
          elements.fuelProgress.style.height = percent + "%";
          
          if (percent <= 20) {
            elements.fuelProgress.style.background = "#c20000";
          } else {
            elements.fuelProgress.style.background = "#FE6F27";
          }
        }
        break;
    }
  });
});