<GameFile>
  <PropertyGroup Name="txk" Type="Node" ID="4550e0f3-8b46-47ec-a53b-41b78e766fd0" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="40" Speed="0.2500" ActivedAnimationName="animation">
        <Timeline ActionTag="-1235937767" Property="Position">
          <PointFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="10" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="20" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="30" X="0.0000" Y="0.0000" />
          <PointFrame FrameIndex="40" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="-1235937767" Property="Scale">
          <ScaleFrame FrameIndex="0" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="10" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="20" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="30" X="1.0000" Y="1.0000" />
          <ScaleFrame FrameIndex="40" X="1.0000" Y="1.0000" />
        </Timeline>
        <Timeline ActionTag="-1235937767" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="10" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="20" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="30" X="0.0000" Y="0.0000" />
          <ScaleFrame FrameIndex="40" X="0.0000" Y="0.0000" />
        </Timeline>
        <Timeline ActionTag="-1235937767" Property="Alpha">
          <IntFrame FrameIndex="0" Value="0" />
          <IntFrame FrameIndex="10" Value="255" />
          <IntFrame FrameIndex="20" Value="148" />
          <IntFrame FrameIndex="30" Value="255" />
          <IntFrame FrameIndex="40" Value="0" />
        </Timeline>
        <Timeline ActionTag="1710120480" Property="VisibleForFrame">
          <BoolFrame FrameIndex="0" Tween="False" Value="False" />
          <BoolFrame FrameIndex="10" Tween="False" Value="True" />
          <BoolFrame FrameIndex="30" Tween="False" Value="True" />
          <BoolFrame FrameIndex="40" Tween="False" Value="False" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="animation" StartIndex="0" EndIndex="40">
          <RenderColor A="255" R="16" G="190" B="69" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="node" ctype="GameNodeObjectData">
        <Children>
          <AbstractNodeData Name="txk_light_1" ActionTag="-1235937767" Alpha="0" Tag="45" IconVisible="True" LeftMargin="-97.5000" RightMargin="-97.5000" TopMargin="-94.0000" BottomMargin="-94.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" IntelliShadingEnabled="False" ctype="SpriteObjectData">
            <Size X="195.0000" Y="188.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="fruitSuper/effect/common/txk_light.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Particle_1" ActionTag="1710120480" VisibleForFrame="False" Tag="46" IconVisible="True" LeftMargin="7.3543" RightMargin="-7.3543" TopMargin="33.0000" BottomMargin="-33.0000" CascadeColorEnabled="True" CascadeOpacityEnabled="True" StretchWidthEnable="False" StretchHeightEnable="False" ctype="ParticleObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position X="7.3543" Y="-33.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="fruitSuper/particle/sglost_txk.plist" Plist="" />
            <BlendFunc Src="770" Dst="1" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>