const registerButtons = document.querySelectorAll(".register-btn");

const eventSelect = document.getElementById("event");

const registrationForm =
    document.getElementById("registrationForm");

const statusMessage =
    document.getElementById("statusMessage");


/* ==============================
   REGISTER BUTTONS
================================= */

registerButtons.forEach(function (button) {

    button.addEventListener("click", function () {

        const eventName =
            button.getAttribute("data-event");

        eventSelect.value = eventName;

        document
            .getElementById("registration")
            .scrollIntoView({
                behavior: "smooth"
            });

    });

});


/* ==============================
   REGISTRATION FORM
================================= */

registrationForm.addEventListener(
    "submit",
    function (event) {

        event.preventDefault();

        const name =
            document.getElementById("name").value.trim();

        const email =
            document.getElementById("email").value.trim();

        const selectedEvent =
            eventSelect.value;


        if (
            name === "" ||
            email === "" ||
            selectedEvent === ""
        ) {

            statusMessage.textContent =
                "Please complete all fields.";

            statusMessage.classList.add("show");

            return;
        }


        statusMessage.textContent =
            "Registration successful! " +
            name +
            ", you are registered for " +
            selectedEvent +
            ".";

        statusMessage.classList.add("show");

        registrationForm.reset();

    }
);


/* ==============================
   MOBILE MENU
================================= */

const menuButton =
    document.querySelector(".menu-btn");

const sidebar =
    document.querySelector(".sidebar");


menuButton.addEventListener("click", function () {

    sidebar.classList.toggle("show");

});