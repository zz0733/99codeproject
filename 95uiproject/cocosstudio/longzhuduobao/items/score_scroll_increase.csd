<GameFile>
  <PropertyGroup Name="score_scroll_increase" Type="Node" ID="5696bb9b-fed1-46cf-9801-c5025e79118b" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="8" Speed="0.5000" ActivedAnimationName="add_scroll">
        <Timeline ActionTag="-99026759" Property="Position">
          <PointFrame FrameIndex="0" X="16.0000" Y="60.0000" />
          <PointFrame FrameIndex="1" X="16.0000" Y="50.0000" />
          <PointFrame FrameIndex="2" X="16.0000" Y="40.0000" />
          <PointFrame FrameIndex="3" X="16.0000" Y="30.0000" />
          <PointFrame FrameIndex="4" X="16.0000" Y="20.0000" />
          <PointFrame FrameIndex="5" X="16.0000" Y="10.0000" />
          <PointFrame FrameIndex="6" X="16.0000" Y="0.0000" />
          <PointFrame FrameIndex="7" X="16.0000" Y="-10.0000" />
          <PointFrame FrameIndex="8" X="16.0000" Y="-20.0000" />
        </Timeline>
        <Timeline ActionTag="-99026759" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="1" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="2" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="3" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="4" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="5" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="6" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="7" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="8" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="-99026759" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="15.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="1" X="10.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="2" X="5.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="3" X="3.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="4" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="5" X="-3.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="6" X="-5.0000" Y="-2.0000" />
          <ScaleFrame FrameIndex="7" X="-10.0000" Y="-2.0000" />
          <ScaleFrame FrameIndex="8" X="-15.0000" Y="-2.0000" />
        </Timeline>
        <Timeline ActionTag="-99026759" Property="FrameEvent">
          <EventFrame FrameIndex="4" Tween="False" Value="num_set" />
          <EventFrame FrameIndex="8" Tween="False" Value="scroll_end" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="add_scroll" StartIndex="0" EndIndex="8">
          <RenderColor A="255" R="8" G="41" B="5" />
        </AnimationInfo>
        <AnimationInfo Name="add_scrollset" StartIndex="0" EndIndex="4">
          <RenderColor A="255" R="212" G="168" B="27" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" ctype="GameNodeObjectData">
        <Children>
          <AbstractNodeData Name="Panel_1" ActionTag="1516452524" Tag="54" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-16.0000" RightMargin="-16.0000" TopMargin="-20.0000" BottomMargin="-20.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FlipX="False" FlipY="False" IsCustomSize="True" ctype="PanelObjectData">
            <Size X="32.0000" Y="40.0000" />
            <Children>
              <AbstractNodeData Name="sprite_numValue" ActionTag="-99026759" Tag="55" RotationSkewX="15.0000" IconVisible="True" TopMargin="-40.0000" BottomMargin="40.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
                <Size X="32.0000" Y="40.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="16.0000" Y="60.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="1.5000" />
                <PreSize X="1.0000" Y="1.0000" />
                <FileData Type="PlistSubImage" Path="godNum_00.png" Plist="longzhuduobao/image/number.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>