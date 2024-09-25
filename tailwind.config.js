/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./lib/bloggy_web/**/*.{ex,heex}", "./assets/js/*.js"],
  theme: {
    
    fontFamily: {
      title: ["Chakra Petch", "sans-serif"]
    },
    extend: {
      colors: {
        skyie: '#73ABDE',
        purr: '#5d69f2',
        topper: '#62a2f3',
        secondary: '#02182B',
        tertiary: '#DDFFF7'
      }
    },
  },
  plugins: [],
}

