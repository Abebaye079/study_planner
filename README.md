# Study Planner App

A flutter mobile application that helps students manage and track their study tasks using full CRUD operations.

## Features

**Create** : Add a new study task with subject, topic, priority and due date.

![Add screen Screenshot](assets/images/Add.png)

**Read** : View all study tasks in a clean card based home screen.

![Home screen Screenshot](assets/images/Read.png)

**Update** : Edit any existing study task.

![Edit screen screenshot](assets/images/Edit.png)

**Delete** : Remove a task with a confirmation dialog.

![Delete screen Screenshot](assets/images/Delete.png)

**Toggle** : mard tasks as complete or incomplete.

**Progress** : track completion progress with a progress bar.

## Error Handling

-Network error message with retry button

![Network Error screenshot](assets/images/net-error.png)

-Form validation on all input fields

![Form Validation screenshot](assets/images/FormValidation.png)

-Empty statewhen no task exist
-SUccess and failure snackbars for all actions

## Loading states

-Loading spinner while fetching data
-Loading spinner on submit buttons

![Loading spinner on submit button screenshot](assets/images/loading.png)


-This app uses [JSONPlaceholder](https://jsonplaceholder.typicode.com)
as the public REST API.
-It used the latest Bloc state management solution for state management and the dio package for making network requests.