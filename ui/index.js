window.addEventListener("message", (event) => {
  let data = event.data;

  if (data.action == "showUI") {
    const showUI = document.querySelector(".container");
    showUI.style.display = "block";
  }

  if (data.action == "hideUI") {
    const hideUI = document.querySelector(".container");
    hideUI.style.display = "none";
  }

  if (data.ServerName != undefined) {
    document.getElementById("ServerName").innerHTML = data.ServerName;
  }

  if (data.Link != undefined) {
    document.getElementById("Link").innerHTML = data.Link;
  }

  if (data.playerName != undefined) {
    document.getElementById("playername").innerHTML = data.playerName;
  }

  if (data.cash != undefined) {
    document.getElementById("mcash").innerHTML = data.cash;
  }

  if (data.bankMoney != undefined) {
    document.getElementById("mbank").innerHTML = data.bankMoney;
  }

  if (data.dob != undefined) {
    document.getElementById("dob").innerHTML = data.dob;
  }

  if (data.job != undefined) {
    document.getElementById("job").innerHTML = data.job + " - " + data.jobgrade;
  }

  if (data.height != undefined) {
    document.getElementById("height").innerHTML = data.height + data.unit;
  }

  if (data.vehicleCount != undefined) {
    document.getElementById("vehicleCount").innerHTML = data.vehicleCount;
  }

  if (data.steam != undefined) {
    document.getElementById("steam").innerHTML = data.steam;
  }

  if (data.group != undefined) {
    document.getElementById("group").innerHTML = data.group;
  }

  if (data.id != undefined) {
    document.getElementById("id").innerHTML = data.id;
  }

  if (data.pp != undefined) {
    document.getElementById("pp").innerHTML = data.pp;
  }

  if (data.sex == "m") {
    document.getElementById("sex").innerHTML = data.Male;
  } else {
    document.getElementById("sex").innerHTML = data.Female;
  }
});

document.addEventListener("keydown", logKey);

function logKey(e) {
  if (e.key == "Escape") {
    fetch(`https://${GetParentResourceName()}/close`);
  }
}

document.getElementById("close").addEventListener("click", function () {
  // Itt írd be a kódodat, ami bezárja a panelt
  // Például, ha a panelnek van egy 'panel' ID-ja, akkor a következő kódot használhatod:
  fetch(`https://${GetParentResourceName()}/close`);
});
