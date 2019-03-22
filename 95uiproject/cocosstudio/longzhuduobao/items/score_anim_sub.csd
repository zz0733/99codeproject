<GameFile>
  <PropertyGroup Name="score_anim_sub" Type="Node" ID="53ca8518-5132-4a52-b0c9-434e5dc01152" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="8" Speed="0.5000" ActivedAnimationName="sub_scroll">
        <Timeline ActionTag="1223389612" Property="Position">
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
        <Timeline ActionTag="1223389612" Property="Scale">
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
        <Timeline ActionTag="1223389612" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="15.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="1" X="10.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="2" X="5.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="3" X="3.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="4" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="5" X="-3.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="6" X="-5.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="7" X="-10.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="8" X="-10.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="1223389612" Property="FrameEvent">
          <EventFrame FrameIndex="0" Tween="False" Value="" />
          <EventFrame FrameIndex="4" Tween="False" Value="num_set" />
          <EventFrame FrameIndex="8" Tween="False" Value="scroll_end" />
        </Timeline>
        <Timeline ActionTag="1223389612" Property="FileData">
          <TextureFrame FrameIndex="0" Tween="False">
            <TextureFile Type="PlistSubImage" Path="godNum_00.png" Plist="longzhuduobao/image/number.plist" />
          </TextureFrame>
        </Timeline>
        <Timeline ActionTag="1223389612" Property="BlendFunc">
          <BlendFuncFrame FrameIndex="0" Tween="False" Src="1" Dst="771" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="sub_scroll" StartIndex="0" EndIndex="8">
          <RenderColor A="255" R="154" G="160" B="127" />
        </AnimationInfo>
        <AnimationInfo Name="sub_scrollset" StartIndex="0" EndIndex="4">
          <RenderColor A="255" R="194" G="104" B="161" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" ctype="GameNodeObjectData">
        <Children>
          <AbstractNodeData Name="Panel_1" ActionTag="-1875289983" Tag="152" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-16.0000" RightMargin="-16.0000" TopMargin="-20.0000" BottomMargin="-20.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="0.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" FlipX="False" FlipY="False" IsCustomSize="True" ctype="PanelObjectData">
            <Size X="32.0000" Y="40.0000" />
            <Children>
              <AbstractNodeData Name="sprite_numValue" ActionTag="1223389612" Tag="153" RotationSkewX="15.0000" IconVisible="True" PositionPercentXEnabled="True" TopMargin="-40.0000" BottomMargin="40.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
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