// Custom javascript code
function hideModal() {
    document.querySelector("#modal").classList.add("fade-out");
    document.querySelector("#modal-content").classList.add("fade-out-scale");
    setTimeout(() => {
      document.querySelector("#modal").style.display = "none";
      document.querySelector("#modal-content").style.display = "none";
    }, 300); // Adjust timing based on your CSS transition duration
  }
  
  document.addEventListener("keydown", e => {
    if (e.key === "Escape") {
      hideModal();
    }
  });
  
  document.addEventListener("click", e => {
    if (e.target.id === "modal") {
      hideModal();
    }
});
  