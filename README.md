# `poke_app`

A simple Flutter application that fetches and displays a list of Pokémon using the [PokeAPI](https://pokeapi.co/). The app uses the `poke_api` package for data fetching and the `flutter_bloc` package for state management following the MVVM (Model-View-ViewModel) architecture.

## Features

- Fetch Pokémon data from the API.
- Search for Pokémon by name.
- Infinite scrolling to load more Pokémon.
- Displays a loading indicator while data is being fetched.
- Displays an error message if the API call fails.

## Installation

To use the `poke_app` application, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/poke_app.git
    ```

2. Install the dependencies:

    ```bash
    flutter pub get
    ```

3. Run the app:

    ```bash
    flutter run
    ```

## Architecture

This app follows the **MVVM (Model-View-ViewModel)** architecture using the `flutter_bloc` package for state management.

### Main Components:

- **HomeScreen (View)**: Displays the list of Pokémon and handles UI interaction like search input and scroll events.
- **HomeBloc (ViewModel)**: Manages the state of the app, fetches data from the API, and handles events like fetching Pokémon or searching by name.
- **PokeApiService (Model)**: Makes HTTP requests to the Pokémon API to fetch data.

### HomeScreen (UI)

The `HomeScreen` is a StatefulWidget that initializes the `HomeBloc` and listens for scrolling events to trigger the fetching of more Pokémon. It provides a search bar for users to filter the Pokémon list by name.

### Bloc Events and States

- **Events:**
  - `OnPokemonsFetched`: Triggered when the user reaches the bottom of the list or when the app is first loaded to fetch more Pokémon.
  - `OnSearchPokemonChanged`: Triggered when the user enters a search term in the search bar.

- **States:**
  - `HomeState`: Holds the current list of Pokémon, loading state, search results, and pagination data.
  - `HomeStatus`: Represents the current status of the state (loading, success, failure).

### Fetching Data

Data is fetched from the [PokeAPI](https://pokeapi.co/), using the `PokeApiService` to make HTTP requests. When the user scrolls to the bottom of the list, more Pokémon are fetched, and a loading indicator is shown until the data is available.

### Infinite Scrolling

The app supports infinite scrolling where more Pokémon are loaded as the user scrolls down. When the end of the list is reached, a loading indicator appears at the bottom until more data is fetched.

## Directory Structure
```bash
lib/
├── main.dart                 # Entry point of the app
├── ui/                       # Contains UI-related code
│   └── app.dart              # Entry point of the Flutter app
│   └── home/                 # HomeScreen UI and Bloc
│       ├── bloc/             # HomeBloc (ViewModel)
│       └── home_screen.dart  # HomeScreen widget
├── data/                 # Contains the poke_api package (Model)
│   └── poke_api_repository.dart # Repository to fetch data from the PokeAPI
```
## Example Usage

To use this app, simply run it after installing the dependencies as mentioned above. The home screen will show a list of Pokémon with infinite scrolling support. You can search for Pokémon by name using the search bar.

## License

This app is licensed under the [MIT License](LICENSE).
