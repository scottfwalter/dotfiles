const canvas = document.getElementById('ballCanvas')
const ctx = canvas.getContext('2d')

// Set canvas size to full window size
canvas.width = window.innerWidth
canvas.height = window.innerHeight

// Ball properties
const ballRadius = 50 // Increased size for better visibility
let ballX = canvas.width / 2
let ballY = canvas.height / 2
let ballSpeedX = 5
let ballSpeedY = 5

// Audio context and oscillator for sound
const audioContext = new (window.AudioContext || window.webkitAudioContext)()
let oscillator

// Function to create a sound
function playSound(frequency) {
  if (oscillator) {
    oscillator.stop()
  }
  oscillator = audioContext.createOscillator()
  oscillator.frequency.setValueAtTime(frequency, audioContext.currentTime)
  oscillator.type = 'square'
  oscillator.connect(audioContext.destination)
  oscillator.start()
  oscillator.stop(audioContext.currentTime + 0.1) // Short beep
}

// Function to draw the Amiga-style boing ball
function drawBall() {
  // Draw the ball with a gradient for a 3D effect
  const gradient = ctx.createRadialGradient(
    ballX,
    ballY,
    ballRadius * 0.1, // Inner circle (highlight)
    ballX,
    ballY,
    ballRadius // Outer circle
  )
  gradient.addColorStop(0, '#ff6666') // Light red (highlight)
  gradient.addColorStop(1, '#cc0000') // Dark red (shadow)

  // Draw the ball body
  ctx.beginPath()
  ctx.arc(ballX, ballY, ballRadius, 0, Math.PI * 2)
  ctx.fillStyle = gradient
  ctx.fill()
  ctx.closePath()

  // Draw the checkerboard pattern
  const checkerSize = ballRadius / 4 // Size of each checker square
  for (let angle = 0; angle < Math.PI * 2; angle += Math.PI / 4) {
    const x = ballX + Math.cos(angle) * ballRadius * 0.7
    const y = ballY + Math.sin(angle) * ballRadius * 0.7
    ctx.fillStyle = Math.floor(angle / (Math.PI / 4)) % 2 === 0 ? 'white' : 'black'
    ctx.beginPath()
    ctx.arc(x, y, checkerSize, 0, Math.PI * 2)
    ctx.fill()
    ctx.closePath()
  }

  // Add a shadow effect
  ctx.shadowColor = 'rgba(0, 0, 0, 0.5)'
  ctx.shadowBlur = 10
  ctx.shadowOffsetX = 5
  ctx.shadowOffsetY = 5
}

// Function to update ball position and handle collisions
function updateBall() {
  ballX += ballSpeedX
  ballY += ballSpeedY

  // Collision with left and right walls
  if (ballX + ballRadius > canvas.width || ballX - ballRadius < 0) {
    ballSpeedX = -ballSpeedX
    playSound(440) // Play a sound when hitting the side walls
  }

  // Collision with top and bottom walls
  if (ballY + ballRadius > canvas.height || ballY - ballRadius < 0) {
    ballSpeedY = -ballSpeedY
    playSound(880) // Play a sound when hitting the top/bottom walls
  }
}

// Function to clear the canvas
function clearCanvas() {
  ctx.clearRect(0, 0, canvas.width, canvas.height)
}

// Main animation loop
function animate() {
  clearCanvas()
  drawBall()
  updateBall()
  requestAnimationFrame(animate)
}

// Start the animation
animate()

// Handle window resize
window.addEventListener('resize', () => {
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
})
