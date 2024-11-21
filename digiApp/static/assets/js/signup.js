let signIn = document.getElementById('sign-in');
let signUp = document.getElementById('sign-up');
let content = document.getElementsByClassName('content');

// Initially display the Sign In content
content[1].style.display = "none";  // Hide Sign Up content by default

signIn.addEventListener('click', function() {
    // Set Sign In tab as active
    this.style.borderBottom = '2px solid #cc1616';
    signUp.style.borderBottom = 'none';

    // Display Sign In content and hide Sign Up content
    content[0].style.display = 'block';
    content[1].style.display = 'none';
});

signUp.addEventListener('click', function() {
    // Set Sign Up tab as active
    this.style.borderBottom = '2px solid #cc1616';
    signIn.style.borderBottom = 'none';

    // Display Sign Up content and hide Sign In content
    content[0].style.display = 'none';
    content[1].style.display = 'block';
});
