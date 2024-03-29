// store some elements
var contactButton = document.getElementById("contact-button");
var contactForm = document.getElementById("contact_me");
var fName = document.getElementsByName("name")[0];
var fEmail = document.getElementsByName("email")[0];
var fMessage = document.getElementsByName("message")[0];

// validate our form inputs
function validate (element, type) {
    var value = element.value;

    // prevent empty inputs
    if (value.length === 0) {
        element.previousElementSibling.style.display = "inline-block";
        return false;
    }

    // if it is for an email
    if (type === "email") {
        var atpos = value.indexOf("@");
        var dotpos = value.lastIndexOf(".");
        if (atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= value.length) {
            element.previousElementSibling.style.display = "inline-block";
            return false;
        }
    }

    // if we get this far it is valid
    element.previousElementSibling.style.display = "none";
    return true;
}

// submit a thing
function formSubmit(event) {
    event.preventDefault();

    var validName = validate(fName);
    var validEmail = validate(fEmail, "email")
    
    if (!validName || !validEmail) {
        contactButton.value = "Check Fields";
        return setTimeout(function() {
            contactButton.value = "Submit";
        }, 2000);
    }

    // make our request
    contactButton.value = 'Sending...';
    fetch('https://formspree.io/f/mvoddgdk', {
        method: "POST",
        body: JSON.stringify({
            name: fName.value,
            email: fEmail.value,
            message: fMessage.value
        }),
        headers: {
            "Content-Type": "application/json"
        },
    }).then(function (response) {
        if (response.status === 302 || response.status === 404) {
            throw new Error();
        }
        var contentType = response.headers.get("content-type");
        if (contentType && contentType.indexOf("application/json") !== -1) {
            return response.json();
        }
        throw new Error();
    }).then(function (data) {
        if (data.error) {
            throw new Error();
        }
        contactButton.value = "Message Sent!";
        setTimeout(function() {
            contactButton.value = "Submit";
        }, 2000);
    }).catch(function (err) {
        contactButton.value = "Try Again";
        setTimeout(function() {
            contactButton.value = "Submit";
        }, 2000);
    });
}

// start listeing for form submission
function startListening () {
    contactForm.addEventListener("submit", formSubmit);
}

// polyfill fetch if required
(function initialise () {
    if (window.fetch) {
        startListening();
    } else {
        var fetchPoly = document.createElement("script");
        fetchPoly.src = "https://cdnjs.cloudflare.com/ajax/libs/fetch/2.0.1/fetch.min.js";
        fetchPoly.onload = startListening;
        document.head.appendChild(fetchPoly);
    }
})();