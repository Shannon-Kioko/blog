/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./lib/bloggy_web/**/*.{ex,heex}", "./assets/js/*.js"],
  theme: {
    
    fontFamily: {
      title: ["Chakra Petch", "sans-serif"]
    },
    extend: {
      colors: {
        skyie: '#73ABDE'
      }
    },
  },
  plugins: [],
}

