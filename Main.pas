uses Graph3D;
uses System.Media;

type
  Button = class
  private
    GameObject: BoxT;
    ObjectText: TextT;
    ObjectName: string;
    IsSel := false;
  protected
    x1: Group3D;
  public
    constructor Create(Name: string; Obj: BoxT; ObjText: TextT);
    begin
      ObjectName := Name;
      GameObject := Obj;
      ObjectText := ObjText;
      ObjectText.Rotate(OrtX, 90);
      GameObject.AddChild(ObjectText);
    end;
    
    procedure Select();
    begin
      IsSel := not IsSel;
      if (IsSel = true) then
        GameObject.Material := Colors.Tomato
      else
        GameObject.Material := Colors.White;
    end;
    
    property IsSelected: boolean read IsSel;
    property Name: string read ObjectName;
    property Position: Group3D read x1;
  end;
  
  Panel = class
  private
    GameObject: BoxT;
    ObjectName: string;
  public
    constructor Create(Name: string; Obj: BoxT);
    begin
      ObjectName := Name;
      GameObject := Obj;
    end;
    
    property Name: string read ObjectName;
    property Obj: BoxT read GameObject;
  end;
  
  Penis = class
  private
    GameObject, Model: Object3D;
    MaxTimeReact: real;
    React: integer;
    MoneyForReact: integer;
    a := Sphere(2, 3, -5, 2, Colors.LightPink);
    s := Sphere(-2, 3, -5, 2, Colors.LightPink);
    d := Sphere(0, -4, -3, 1.5, Colors.Maroon);
     f := Cylinder(0, 3, -3, 7, 1.5, Colors.LightPink);
  public
    constructor Create(Obj: Object3D; Color1: System.Windows.Media.Color; MaxTime, React1, Money: integer);
    begin
      f.Rotate(OrtX, 90);
      GameObject := f;
      
      Model := Group(a, s, d, f);
      //GameObject.Color := Color1;
      MaxTimeReact := MaxTime;
      React := React1;
      MoneyForReact := Money;
    end;
    
    property Obj: Object3D read GameObject;
    property MaxTimeReaction: real read MaxTimeReact;
    property Reaction: integer read React;
    property MoneyForReaction: integer read MoneyForReact;
  end;

var
  //Общие кнопки
  StartButton,
  CloseButton,
  CancelButton,
  BuyButton,  
  //Кнопки магазина
  ShopButton,
  UpClickButton,
  UpAutoButton,
  BoosterButton,
  //Кнопки декора
  DecorButton,
  UpFonButton,
  UpMusicButton,
  UpExtraButton: Button;
  
  MainPanel,
  FonPanel,
  ShopPanel,
  DecorPanel,
  UpClickPanel,
  UpAutoPanel,
  BoosterPanel,
  UpFonPanel,
  UpMusicPanel,
  UpExtraPanel: Panel;
  
  PanelMaterial := Materials.Image('PanelFon2.jpg', 1, 1);
  FonMaterial := Materials.Image('Fon1.jpg', 1, 1);
  
  MainPenis: Penis;
  
  Timer,
  ReactionCounter,
  MoneyCounter: TextT;
  
  Money, Tap: integer;

procedure ClickShop();
begin
  ShopButton.Select();
  if (ShopButton.IsSelected) then
  begin
    MainPanel.GameObject.AnimMoveOnY(-10, 1).Begin;
    ShopPanel.GameObject.AnimMoveOnY(-10, 1).Begin;
  end
    else
  begin
    MainPanel.GameObject.AnimMoveOnY(10, 1).Begin;
    ShopPanel.GameObject.AnimMoveOnY(10, 1).Begin;
  end;
end;

procedure ClickDecor();
begin
  DecorButton.Select();
  if (DecorButton.IsSelected) then
  begin
    MainPanel.GameObject.AnimMoveOnY(-10, 1).Begin;
    DecorPanel.GameObject.AnimMoveOnY(-10, 1).Begin;
  end
    else
  begin
    MainPanel.GameObject.AnimMoveOnY(10, 1).Begin;
    DecorPanel.GameObject.AnimMoveOnY(10, 1).Begin;
  end;
end;

procedure ClickPenis();
begin
  Tap += 1;
  if ((100 / MainPenis.React) * tap >= 100) then
  begin
    Money += MainPenis.MoneyForReaction;
    MoneyCounter.Text := Money + '$';
    tap := 0;
    MainPenis.React += Random(1, 10);
    MainPenis.MoneyForReact += Random(1, 5);
    MainPenis.MaxTimeReact := 30;
  end;
  ReactionCounter.Text := 'Orgasm: ' + Round((100 / MainPenis.React) * tap) + '%';
end;

procedure Click(x, y: real; mb: integer);
begin
  var ClickedObject := FindNearestObject(x, y);
  if (ClickedObject = CloseButton.GameObject) or (ClickedObject = CloseButton.ObjectText) then
  begin
    Window.Close;
  end else
  if (((ClickedObject = ShopButton.GameObject) or (ClickedObject = ShopButton.ObjectText)) and (not DecorButton.IsSelected)) then
  begin
    ClickShop();
  end;
  if (((ClickedObject = DecorButton.GameObject) or (ClickedObject = DecorButton.ObjectText)) and (not ShopButton.IsSelected)) then
  begin
    ClickDecor();
  end;
  if (ClickedObject = MainPenis.GameObject) then
  begin
    ClickPenis();
  end;
end;

procedure LoadGame();
begin
  
  Camera.Position := new Point3D(0, 0, 18.5);
  Camera.LookDirection := new Vector3D(0, 0, -18.5);
  Camera.UpDirection := new Vector3D(0, -1, 0);
  Window.SetSize(600, 800);
  Window.CenterOnScreen;
  Window.IsFixedSize := true;
  Window.Caption := 'Simulator Mastrubation';
  View3D.HideAll();
  var gr := new GridLinesType();
  gr.Length := 14;
  gr.Width := 20;
  
  ShopPanel := new Panel('', Box(0, 13, -0.06, 14, 5, 0.1, PanelMaterial));
  UpClickButton := new Button('', Box(5, 0, 0.05, 2, 2, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Up Click', 0.5, 'Arial', Colors.Black));
  UpClickPanel := new Panel('', Box(14, 5, -0.06, 14, 5, 0.1, PanelMaterial));
  UpClickPanel.GameObject.Rotate(OrtZ, 180);
  UpAutoButton := new Button('', Box(0, 0, 0.05, 2, 2, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Up Auto', 0.5, 'Arial', Colors.Black));
  UpAutoPanel := new Panel('', Box(0, 5, -0.06, 14, 5, 0.1, PanelMaterial));
  BoosterButton := new Button('', Box(-5, 0, 0.05, 2, 2, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Boosters', 0.5, 'Arial', Colors.Black));
  BoosterPanel := new Panel('', Box(-14, 5, -0.06, 14, 5, 0.1, PanelMaterial));
  BoosterPanel.GameObject.Rotate(OrtZ, 180);
  ShopPanel.GameObject.AddChilds(UpClickButton.GameObject, UpAutoButton.GameObject, BoosterButton.GameObject, UpClickPanel.GameObject, UpAutoPanel.GameObject, BoosterPanel.GameObject);
  
  DecorPanel := new Panel('', Box(0, 13, -0.06, 14, 5, 0.1, PanelMaterial));
  UpFonButton := new Button('', Box(5, 0, 0.05, 2, 2, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Fon', 0.5, 'Arial', Colors.Black));
  UpFonPanel := new Panel('', Box(14, 5, -0.06, 14, 5, 0.1, PanelMaterial));
  UpFonPanel.GameObject.Rotate(OrtZ, 180);
  UpMusicButton := new Button('', Box(0, 0, 0.05, 2, 2, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Music', 0.5, 'Arial', Colors.Black));
  UpMusicPanel := new Panel('', Box(0, 5, -0.06, 14, 5, 0.1, PanelMaterial));
  UpExtraButton := new Button('', Box(-5, 0, 0.05, 2, 2, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Extra', 0.5, 'Arial', Colors.Black));
  UpExtraPanel := new Panel('', Box(-14, 5, -0.06, 14, 5, 0.1, PanelMaterial));
  UpExtraPanel.GameObject.Rotate(OrtZ, 180);
  DecorPanel.GameObject.AddChilds(UpFonButton.GameObject, UpMusicButton.GameObject, UpExtraButton.GameObject, UpExtraPanel.GameObject, UpFonPanel.GameObject, UpMusicPanel.GameObject);
  
  MainPanel := new Panel('', Box(0, 8, -0.06, 14, 5, 0.1, PanelMaterial));
  CloseButton := new Button('', Box(-6.5, -9.5, -0.05, 1, 1, 0.1, Colors.Red), Text3D(0, 0, 0.051, 'X', 1, 'Arial', Colors.Black));
  ShopButton := new Button('', Box(5, 0, 0.05, 3, 3, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Shop', 1, 'Arial', Colors.Black));
  DecorButton := new Button('', Box(1.5, 0, 0.05, 3, 3, 0.1, Colors.White), Text3D(0, 0, 0.051, 'Decor', 1, 'Arial', Colors.Black));
  MainPanel.GameObject.AddChilds(ShopButton.GameObject, DecorButton.GameObject);
  
  FonPanel := new Panel('', Box(0, 0, -5, 20, 26, 0.1, FonMaterial));
  MainPenis := new Penis(Cube(0, 0, 0, 0.0001, Colors.White), Colors.Brown, 30, 10, 5);
  
  Timer := Text3D(3.5, -9.5, -1, 'Time: ' + MainPenis.MaxTimeReact.ToString, 2, 'Arial', Colors.Red);
  Timer.Rotate(OrtX, 90);
  ReactionCounter := Text3D(3.5, -7.5, -1, 'Orgasm: ' + 0 + '%', 1.5, 'Arial', Colors.Red);
  ReactionCounter.Rotate(OrtX, 90);
  MoneyCounter := Text3D(-3.5, 7.5, 1, 0 + '$', 1.5, 'Arial', Colors.Black);
  MoneyCounter.Rotate(OrtX, 90);
end;

begin
  LoadGame();
  OnMouseDown += Click;
  while (true) do
  begin
    MainPenis.MaxTimeReact -= 0.1;
    Timer.Text := 'Time: ' + Round(MainPenis.MaxTimeReact);
    Sleep(100);
  end;
end.