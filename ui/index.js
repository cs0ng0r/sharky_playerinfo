window.addEventListener("message", (event) => {
  const data = event.data;

  const showUI = document.querySelector(".container");

  if (data.action === "showUI") {
    showUI.style.display = "block";
    updateUI(data);
  } else if (data.action === "hideUI") {
    showUI.style.display = "none";
  }
});

function updateUI(data) {
  const elements = {
    ServerName: "ServerName",
    Link: "Link",
    playerName: "playername",
    cash: "mcash",
    bankMoney: "mbank",
    dob: "dob",
    job: "job",
    height: "height",
    vehicleCount: "vehicleCount",
    steam: "steam",
    group: "group",
    id: "id",
    sex: "sex",
  };

  for (const [key, elementId] of Object.entries(elements)) {
    if (data[key] !== undefined) {
      document.getElementById(elementId).innerHTML =
        key === "job"
          ? `${data.job} - ${data.jobgrade}`
          : key === "height"
          ? `${data.height} ${data.unit}`
          : data[key];
    }
  }

  // Update the sex element based on the gender
  document.getElementById("sex").innerHTML = data.sex === "m" ? "Férfi" : "Nő";
}

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    closePanel();
  }
});

document.getElementById("close").addEventListener("click", closePanel);

function closePanel() {
  fetch(`https://sharky_playerinfo/close`);
}
