Stack<State> state_stack;

ImageProcessing ip;
PGraphics mainFrame;
long frameID;

void settings()
{
    size(1920, 1080, P2D);
}

void setup()
{
    ip = new ImageProcessing();
    mainFrame = createGraphics(width,height,P3D);
    mainFrame. textureWrap(REPEAT);
    mainFrame.textureMode(NORMAL);
    noStroke();
    state_stack = new Stack<State>();
    push_state(new MenuState());
    frameID = 0;
}

void push_state(State s)
{
    if(!state_stack.empty()) {
        State os = state_stack.peek();
        os.on_pause(this);
    }
    state_stack.push(s);
    s.on_begin(mainFrame,this);
}

void pop_state()
{
    if(!state_stack.empty()) {
        State s = state_stack.pop();
        println("Poping state " + s);
        s.on_end(this);
    }
    if(!state_stack.empty()) {
        State s = state_stack.peek();
        println("resume state " + s);
        s.on_resume(this); //<>// //<>//
    }
}

void replace_state(State s)
{
    pop_state();
    push_state(s);
}

void draw()
{
    if(state_stack.empty())
        return;

    State s = state_stack.peek();
    s.on_update(0.017,this);
    mainFrame.beginDraw();
    s.on_draw(mainFrame,this);
    mainFrame.endDraw();

    image(mainFrame,0,0);
}

void mouseDragged(MouseEvent event)
{
    if(!state_stack.empty())
        state_stack.peek().on_mouseDragged(event);
}

void mouseWheel(MouseEvent event)
{
    if(!state_stack.empty())
        state_stack.peek().on_mouseWheel(event);

}

void keyPressed(KeyEvent e)
{
    if(!state_stack.empty())
        state_stack.peek().on_keyPressed(e);
}

void mouseClicked(MouseEvent e)
{
    if(!state_stack.empty())
        state_stack.peek().on_mouseClicked(e);
}

void keyReleased(KeyEvent e)
{
    if(!state_stack.empty())
        state_stack.peek().on_keyReleased(e);
}