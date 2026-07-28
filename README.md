# Building a SwiftUI with Ghibli API

the project was build with the following:
- iOS 26+
- SwiftUI with Observation feature for better performance
- URLSession with async/await
- MVVM with service layer
- testing with Swift Testing 

API [documentation](https://ghibliapi.vercel.app/) for Studio Ghibli:
- base URL: https://ghibliapi.vercel.app/
- endpoints used: /films /people
- no authentication required

## Features of the Reference Project

- TabView with Navigation Stacks
- List Screen (fetch from API, show list of items).
- Detail Screen (display more info, async image loading).
  
<p float="left">
  <img src="images/ghibli_movie_list.jpeg" width="40%" />
  <img src="/images/ghibli_movie_detail.jpeg" width="40%" /> 
</p>

- Favorites (local persistence).
  
<img src="/images/ghibli_favorites.jpeg" width=40%>

- Search (filter + async debounce).
  
<img src="/images/ghibli_search.jpeg" width=40%>

- Settings (theme, stored in UserDefaults).
  
<img src="/images/ghibli_settings.jpeg" width=40%>


- testing, mocks, & dependency injection






